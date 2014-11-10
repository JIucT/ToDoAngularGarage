var todoApp = angular.module('todoListApp', [/*"xeditable", "ngAnimate", "ui.sortable", "ui.bootstrap"*/]);

todoApp.config  (function($httpProvider) {
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
});

todoApp.run(function(editableOptions) {
  editableOptions.theme = 'bs3';
});

todoApp.controller('ProjectsCtrl', ['$scope', '$http', '$timeout', function ($scope, $http, $timeout) {

  $http.get('/projects.json').success(function(data) {
    $scope.projects = data;  
  });

  $scope.taskValid = function(newTitle, project) {
    if (newTitle.length < 4) {
      return false;
    }    
    for(var i=0; i<project.tasks.length;i++) {
      if (project.tasks[i].title == newTitle) {
        return false;
      }
    }    
    return true;
  }

  $scope.addProject = function(){
    $http.post("/projects", { project: { title: "Enter project name" } })
      .success(function(data, status, headers, config) {
        $scope.projects.unshift( data );
      })
      .error(function(data, status, headers, config) {
        alert( "Oops. Sorry something went wrong try again later" );
      });
  }

  $scope.remove = function(project) {
    if(confirm('All project data will be deleted')) {
      var id = project.id;
      $http.delete("/projects/"+id, { project: { id: id }});
      $scope.projects.splice($scope.projects.indexOf(project), 1);
    }
  }

  $scope.updateTitle = function(id){
    $http.patch("/projects/"+id, { project: { title: this.$data, id: id } });
  }

  $scope.addTask = function(event, project) {
    var inputElem = angular.element(".task-name[data-name='" + project.id + "']");    
    if (!$scope.taskValid(inputElem.val(), project)) {
      inputElem.css("border-color", "red");
      inputElem.css("border-width", "2px");
    } else {
      $http.post("/projects/"+project.id+"/tasks", { 
        task: { title: inputElem.val(), project_id: project.id }})
        .success(function(data, status, headers, config) {
          project.tasks = data;
          inputElem.val('');
          inputElem.css("border-width", "0px");
          $timeout(function() {
            $scope.$apply(); 
          });             
        })
        .error(function(data, status, headers, config) {
          alert( "Oops. Sorry something went wrong try again later" );
        });
    }
  }

  $scope.changeTaskState = function(task) {
    var textElem = angular.element("#"+task.id);
    if (task.completed){
      textElem.css("text-decoration", "line-through");      
    } else {
      textElem.css("text-decoration", "none");            
    }    
    $http.patch("/projects/"+task.project_id+"/tasks/"+ task.id, 
      { task: { completed: task.completed, id: task.id } })
      .error(function(data, status, headers, config) {
        if (task.completed){
          task.completed = false;
          textElem.css("text-decoration", "none");          
        } else {
          textElem.css("text-decoration", "line-through");         
          task.completed = true;
        }
        alert( "Oops. Sorry something went wrong try again later" );
      });
  }

  $scope.validateTaskTitle = function(project) {
    var editableInput = angular.element(".task-data form input");
    if (!$scope.taskValid(editableInput.val(), project)) {
      return false;    
    }
  }

  $scope.updateTaskTitle = function(task) {
    $http.patch("/projects/"+task.project_id+"/tasks/"+ task.id, { task: { title: task.title, id: task.id } });
  }

  $scope.removeTask = function(event, task, project) {
    if(confirm('All task data will be deleted')) {
      $http.delete("/projects/"+task.project_id+"/tasks/"+ task.id);
      for (var i in project.tasks) {
        if (project.tasks[i].priority > task.priority) {
          project.tasks[i].priority--;
        }
      }
      project.tasks.splice(project.tasks.indexOf(task), 1);
    }
  }

  $scope.changeTaskDeadline = function(task) {
    $http.patch("/projects/"+task.project_id+"/tasks/"+ task.id, { task: { 
      deadline: task.deadline.getFullYear().toString() + '-' +
      (task.deadline.getMonth()+1).toString() + '-' + 
      task.deadline.getDate().toString(), id: task.id } });
  }

  $scope.showComments = function(task) {
    var commentsElem = angular.element(".comments-row-" + task.id);
    if (commentsElem.css("display") == 'none' ){
      commentsElem.css("display", "table-row");  
    } else {
      commentsElem.css("display", "none");
    }
  }

  $scope.onCommentAttachment = function(element, scope) {
     $scope.$apply(function(scope) {
        var elem = angular.element(".file-input-label-" + element.attributes['data'].value).val(element.files[0].name);
     });
  }

  $scope.addComment = function(event, task) {
    var comentElem = angular.element("#comment-"+task.id);
    if (comentElem.val().length < 4) {
      comentElem.css("border-color", "red");
      comentElem.css("border-width", "2px");
      return false;
    } else {
      comentElem.css("border-color", "#CCCCCC");
      comentElem.css("border-width", "1px");      
    }

    $.ajax( {
      url: "/projects/"+task.project_id+"/tasks/"+task.id+"/comments",
      type: 'POST',
      data: new FormData( event.target ),     
      processData: false,
      contentType: false
    }).done(function(data){
      angular.element(".file-input-label-"+task.id).val('');
      angular.element(".comment-file-"+task.id).val('');
      comentElem.val('');
      task.comments.push(data);      
      $timeout(function(){
        $scope.$apply(); 
        var commentsElem = $(".comments-row-" + task.id);
        commentsElem.css("display", "table-row");        
      }, 1);          
    });
  }

  $scope.removeComment = function(event, comment, task) {
    if(confirm('All comment data will be deleted')) {
      $http.delete("/projects/"+task.project_id+"/tasks/"+task.id+"/comments/"+comment.id);
      task.comments.splice(task.comments.indexOf(comment), 1);
    }
  }  

  $scope.dragControlListeners = {
    accept: function (sourceItemHandleScope, destSortableScope) {
      return sourceItemHandleScope.itemScope.sortableScope.$id === destSortableScope.$id;
    },
    orderChanged: function(event) {
      var changedTask = event.source.itemScope.task;
      var project = event.source.itemScope.project;
      var newPriority = project.tasks.length - (event.dest.index+1);
      var oldPriority = changedTask.priority;
      var tasks = project.tasks;
      for (var i=0; i<tasks.length; i++) {
        if ((tasks[i].priority>oldPriority) && (tasks[i].priority<=newPriority)){
          tasks[i].priority--;
        } else if ((tasks[i].priority<=oldPriority) && (tasks[i].priority>=newPriority)) {
          tasks[i].priority++;
        }
      }
      tasks[tasks.indexOf(changedTask)].priority = newPriority;
      $scope.projects[$scope.projects.indexOf(project)].tasks = tasks;

      changedTask.priority = project.tasks.length - (event.dest.index+1);
      $http.patch("/projects/"+changedTask.project_id+"/tasks/"+changedTask.id+
        "/update_task_prioity", { 
        task: { project_id: changedTask.project_id, id: changedTask.id, 
        priority: (project.tasks.length - (event.dest.index+1)) }})
        .success(function(data, status, headers, config) {
          $scope.projects[$scope.projects.indexOf(project)].tasks = data;
        })
    },
    containment: '#board'//optional param.
  };


//*****************Datepicker***********
  $scope.today = function() {
    $scope.dt = new Date();
  };
  $scope.today();

  $scope.clear = function () {
    $scope.dt = null;
  };

  $scope.toggleMin = function() {
    $scope.minDate = $scope.minDate ? null : new Date();
  };
  $scope.toggleMin();

  $scope.open = function($event, task) {
    $event.preventDefault();
    $event.stopPropagation();

    task.isOpen = true;
  };

  $scope.dateOptions = {
    formatYear: 'yy',
    startingDay: 1,
    showWeeks: false
  };

  $scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate'];
  $scope.format = $scope.formats[3];

}]);

