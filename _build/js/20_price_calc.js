$(function () {
  var installFee = 1200;
  var costPerDistance = 1.5;
  var monthlyFeePer100Students = 12;
  var minMonthlyFee = 30;
  var discountLongRun = 0.9;
  var longRunYears = 3;

  var compInstallFee = 595 + 830;
  var compCostPerDistance = 1.9;
  var compYearlyFee = [
    [ 100, 180 ],
    [ 200, 300 ],
    [ 300, 400 ],
    [ 400, 500 ],
    [ 600, 680 ],
    [ 800, 850 ],
    [ 1000, 1000 ],
    [ 1200, 1150 ],
    [ 1400, 1290 ],
    [ 1600, 1420 ],
    [ 1800, 1550 ],
    [ 2000, 1680 ]
  ];

  var winLicencePerTeacherYearly = 57;

  var distance = 100;
  var studentCount = 400;
  var contractTime = 3;
  var teacherCount = 30;

  var currentOwnTotal = 0, currentCompTotal = 0;

  if (!$('#priceCalcMain').length) {
    return;
  }

  function setValues() {
    var contractTimeStr = (contractTime === 1) ? 'Jahr' : 'Jahre';
    $('.js-contract-time').text(contractTime + ' ' + contractTimeStr);
    $('.js-student-count').text(studentCount + ' Schüler');
    $('.js-teacher-count').text(teacherCount + ' Lehrer');
    $('.js-distance').text(distance + ' km');
  }


  function formatCurrency(amount) {
    var str = amount + '';

    if (amount >= 1000) {
      str = Math.floor(amount / 1000) + '.' + str.substr(-3, 3);
    }

    return str + ' €';
  }

  function updateOwn() {
    var initialFee, monthlyFee, totalCost, avgCost;

    monthlyFee = studentCount / 100 * monthlyFeePer100Students;

    $('.js-monthly-fee-discount').addClass('invisible');

    if (contractTime >= longRunYears) {
      monthlyFee = Math.round(monthlyFee * discountLongRun);
      $('.js-monthly-fee-discount').removeClass('invisible');
    }

    initialFee = installFee + Math.round(distance * costPerDistance);

    monthlyFee = Math.max(monthlyFee, minMonthlyFee);

    totalCost = initialFee;
    totalCost += monthlyFee * 12 * contractTime;

    currentOwnTotal = totalCost;

    avgCost = Math.round(totalCost / contractTime);

    $('.js-initial-fee').text(formatCurrency(initialFee));
    $('.js-monthly-fee').text(formatCurrency(monthlyFee));
    $('.js-total-cost').text(formatCurrency(totalCost));
    $('.js-avg-cost').text(formatCurrency(avgCost));
  }


  // use Math.floor for all competitor prices
  function updateComp() {
    var i, initialFee, monthlyFee, totalCost, avgCost, winMonthly;

    for (i = 0; i < compYearlyFee.length; i += 1) {
      monthlyFee = Math.floor(compYearlyFee[i][1] / 12);
      if (studentCount <= compYearlyFee[i][0]) {
        break;
      }
    }

    winMonthly = Math.floor(winLicencePerTeacherYearly * teacherCount / 12);

    initialFee = compInstallFee + Math.floor(distance * compCostPerDistance);

    totalCost = initialFee;
    totalCost += (winMonthly + monthlyFee) * 12 * contractTime;

    currentCompTotal = totalCost;

    avgCost = Math.floor(totalCost / contractTime);

    $('.js-initial-fee-comp').text(formatCurrency(initialFee));
    $('.js-monthly-fee-comp').text(formatCurrency(monthlyFee));
    $('.js-monthly-win-comp').text(formatCurrency(winMonthly));
    $('.js-total-cost-comp').text(formatCurrency(totalCost));
    $('.js-avg-cost-comp').text(formatCurrency(avgCost));
  }

  function updateSavings() {
    var percent = Math.round(
      100 * (currentCompTotal - currentOwnTotal) / currentCompTotal
    );

    $('.js-savings').
    removeClass('text-warning text-success').
    addClass((percent >= 0) ? 'text-success' : 'text-warning').
    text(percent + ' %');
  }

  function update() {
    setValues();
    updateOwn();
    updateComp();
    updateSavings();
  }

  update();

  $('.js-student-count-slider').noUiSlider({
    range: [ 100, 2000 ],
    start: studentCount,
    step: 100,
    handles: 1,
    connect: 'lower',
    slide: function () {
      studentCount = $(this).val();
      update();
    }
  });

  $('.js-teacher-count-slider').noUiSlider({
    range: [ 5, 300 ],
    start: teacherCount,
    step: 5,
    handles: 1,
    connect: 'lower',
    slide: function () {
      teacherCount = $(this).val();
      update();
    }
  });

  $('.js-contract-time-slider').noUiSlider({
    range: [ 1, 15 ],
    start: contractTime,
    step: 1,
    handles: 1,
    connect: 'lower',
    slide: function () {
      contractTime = $(this).val();
      update();
    }
  });

  $('.js-distance-slider').noUiSlider({
    range: [ 0, 1000 ],
    start: distance,
    step: 10,
    handles: 1,
    connect: 'lower',
    slide: function () {
      distance = $(this).val();
      update();
    }
  });


});

