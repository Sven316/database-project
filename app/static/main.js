$(document).ready(function() {
  // get current URL path and assign 'active' class
  const pathname = window.location.pathname;
  $('nav li > a[href="'+pathname+'"]').addClass('active');

  // $.getJSON('http://api.fixer.io/latest?base=USD', function(data) {
  //   console.log(data);
  // });

  // set hidden input value for review deletion
  $('.delete').click(function() {
    const id = $(this).data('id');
    $('#deleteReviewModal input.form-control').val(id);
  });

  // if city ID does not exist in set cityID in local storage after adding a city
  if (pathname == '/profile') {
    const city_id = $('#city_id').val()
    localStorage.setItem('city_id', city_id);
  }

  // clear local storage if user deletes the city profile
  if (pathname == '/deleteCity') {
    window.localStorage.clear();
  }


  function setReviewsURL() {
    const city_id = localStorage.getItem('city_id');
    $('.yourreviews a').attr('href', "/yourreviews/"+ city_id +"");
  }
  setReviewsURL();

  // if city ID exists in local storage
  if (localStorage.getItem('city_id') !== null) {
    $('.yourreviews').show();
    $('.nav-id').show();
    // show ID in nav bar
    const city_id = localStorage.getItem('city_id');
    $('#navIDNum').text(city_id);

    // auto fill city ID field then writing a review
    if (pathname == '/review') {
      city_id = localStorage.getItem('city_id');
      $('#city_id').val(city_id);
    }
  }

  function setProfileURL() {
    const city_id = localStorage.getItem('city_id');
    $('.nav-id a').attr('href', "/profile/"+ city_id +"");
  }
  setProfileURL();


})