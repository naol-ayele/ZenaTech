document.addEventListener('DOMContentLoaded', function () {
  var editorContainer = document.getElementById('editor-container');
  if (!editorContainer) return;

  var quill = new Quill('#editor-container', {
    theme: 'snow',
    modules: {
      toolbar: [
        [{ header: [2, 3, false] }],
        ['bold', 'italic', 'underline'],
        ['link'],
        ['blockquote'],
        [{ list: 'ordered' }, { list: 'bullet' }],
        ['clean']
      ]
    }
  });

  var hiddenField = document.getElementById('content-hidden');
  var existingContent = hiddenField.value;
  if (existingContent) {
    quill.root.innerHTML = existingContent;
  }

  document.querySelector('form').addEventListener('submit', function () {
    var html = quill.root.innerHTML;
    hiddenField.value = html === '<p><br></p>' ? '' : html;
  });
});
