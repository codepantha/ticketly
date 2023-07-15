// add 'ajax:success' event listener to every element on the page
// with a 'remove' class that exists inside of an element with a 'tags' class.

window.addEventListener('DOMContentLoaded', () => {
  const tags = document.getElementsByClassName('tags');
  const removeEls = tags[0].getElementsByClassName('remove');

  for (let removeEl of removeEls) {
    removeEl.addEventListener('ajax:success', () => {
      removeEl.parentElement.remove();
    });
  }
});