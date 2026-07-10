function addAffiliateRow() {
  var div = document.createElement('div');
  div.className = 'affiliate-row';
  div.innerHTML = '<input type="text" name="affiliate_label[]" placeholder="Label (e.g. Buy on Amazon)">' +
    '<input type="url" name="affiliate_url[]" placeholder="URL">' +
    '<button type="button" class="btn-remove" data-remove>✕</button>';
  document.getElementById('affiliate-links').appendChild(div);
}

document.addEventListener('DOMContentLoaded', function () {
  document.addEventListener('click', function (e) {
    if (e.target.matches('[data-remove]')) {
      e.target.parentElement.remove();
    }
    if (e.target.matches('.add-link-btn')) {
      addAffiliateRow();
    }
  });

  document.addEventListener('submit', function (e) {
    if (e.target.matches('.delete-form')) {
      if (!confirm(e.target.getAttribute('data-confirm') || 'Delete this article?')) {
        e.preventDefault();
      }
    }
  });
});
