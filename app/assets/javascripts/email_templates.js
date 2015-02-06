// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
   initializeEditors();

   $("#update-templates").click(function( event ) {
       event.preventDefault();

       //Set WYSIWYG editor contents to hidden fields before submit
       var editors = $(".summernote-editor");
       for (var i = 0; i < editors.size(); i++) {
           var editor = editors[i];
           var hidden_field = $(editor).next().next();
           $(hidden_field).val($(editor).code());
       }

       $(".email-templates").submit();
   });
});