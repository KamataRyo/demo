$(function () {
    $('.content').hover(function () {
        $('.caption1', this).animate({
            top: "75px"
        }, 500);
    }, function () {
        $('.caption1', this).animate({
            top: "150px"
        }, 500);
    });
});
