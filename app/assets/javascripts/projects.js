var todoApp = angular.module('todoListApp', ["xeditable"]);

todoApp.run(function(editableOptions) {
  editableOptions.theme = 'bs3';
});

todoApp.controller('ProjectsCtrl', function ($scope, $http) {
  $http.get('/projects.json').success(function(data) {
    $scope.projects = data;
  });

  $scope.addProject = function(){
    $http.post("/projects", { project: { title: "" } })
      .success(function(data, status, headers, config) {
        $scope.projects.unshift( data );
      })
      .error(function(data, status, headers, config) {
        alert( "Oops. Sorry something went wrong try again later" );
      });
  }

  $scope.updateTitle = function(event){
    id = this.project.id;
    $http.patch("/projects/"+id, { project: { title: this.$data, id: id } })
  }

});



// $(document).ready( function() {
//   $(".project-name").text().change(function() {
//     $.post("/projects/" + $(this).val(), { 
//       project: { title: $(this).text(), id: $(this).val() }})
//   });
// });
