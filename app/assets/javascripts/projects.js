var todoApp = angular.module('todoListApp', ["xeditable", "ngAnimate", "ui.sortable"/*, "ui.sortable"*/]);

todoApp.config  (function($httpProvider) {
  authToken = $("meta[name=\"csrf-token\"]").attr("content");
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken;
})

todoApp.run(function(editableOptions) {
  editableOptions.theme = 'bs3';
});

todoApp.controller('ProjectsCtrl', function ($scope, $http, $timeout) {

  $http.get('/projects.json').success(function(data) {
    $scope.projects = data;
  });

  // $scope.sortableOptions = {
  //   stop: function(e, ui) {
  //     console.log(e);
  //     console.log(ui);
  //   }
  // };    

  $scope.addProject = function(){
    $http.post("/projects", { project: { title: "Enter project name" } })
      .success(function(data, status, headers, config) {
        $scope.projects.unshift( data );
      })
      .error(function(data, status, headers, config) {
        alert( "Oops. Sorry something went wrong try again later" );
      });
  }

  $scope.remove = function(event) {
    if(confirm('All project data will be deleted')) {
      var element = angular.element(event.target);
      var id = element.data('value');
      var projectElement = element.parent().parent().parent().parent();
      $http.delete("/projects/"+id, { project: { id: id }});
      projectElement.remove();
    }
  }

  $scope.updateTitle = function(id){
    $http.patch("/projects/"+id, { project: { title: this.$data, id: id } });
  }

  $scope.addTask = function(event, project) {
    var element = angular.element(event.target);
    var inputElem = angular.element(".task-name[data-name='" + project.id + "']");    
    if (inputElem.val().length < 4) {
      inputElem.css("border-color", "red");
      inputElem.css("border-size", "3px");
    } else {
      $http.post("/projects/"+project.id+"/tasks", { 
        task: { title: inputElem.val(), project_id: project.id }})
        .success(function(data, status, headers, config) {
          project.tasks.push(data);
          inputElem.css("border-color", "#CCCCCC");
          inputElem.css("border-size", "1px");
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

  $scope.updateTaskTitle = function(task) {
    console.log("alala");
    $http.patch("/projects/"+task.project_id+"/tasks/"+ task.id, { task: { title: task.title, id: task.id } });
  }

  $scope.removeTask = function(event, task, project) {
    if(confirm('All task data will be deleted')) {
      $http.delete("/projects/"+task.project_id+"/tasks/"+ task.id);
      // angular.element(event.target).remove();
      for (var i in project.tasks) {
        if (project.tasks[i].priority > task.priority) {
          project.tasks[i].priority--;
        }
      }
      project.tasks.splice(project.tasks.indexOf(task), 1);
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
            console.log("aaka");
            tasks[i].priority++;
          }
        }
        tasks[tasks.indexOf(changedTask)].priority = newPriority;
        $scope.projects[$scope.projects.indexOf(project)].tasks = tasks;

        changedTask.priority = project.tasks.length - (event.dest.index+1);
        console.log(event.dest.index);
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

});


todoApp.controller('TasksCtrl', function ($scope, $http) {

})