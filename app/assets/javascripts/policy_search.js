var minCharsBeforeSearch      = 3,
    previousPolicySearchValue = null,
    policySuggestionResults   = null,
    policySearchRequest       = null,
    $policySearchResults      = null,
    $policySearchGroup        = null,
    $policySearchSpinner      = null,
    $policySearchWrapper      = null;

function policySearchListenerAndResults() {
  setPolicySearchElements();

  var timeout = null;

  $policySearchGroup.keyup(function (e) {
    clearTimeout(timeout);

    if (e.key === 'Enter') e.preventDefault();
    if (e.key === 'Escape') {
      $policySearchSpinner.fadeOut();
      $policySearchWrapper.fadeOut();
      $policySearchResults.html('');
      $policySearchResults.addClass('hidden');
    }

    timeout = setTimeout(function () {
      showPolicySearchResultsAsTypeaheadSuggestions();
    }, 1000);
  });

  $policySearchGroup.click(function (event) {
    if (event.target.parentNode.id === '') {
      // console.log('previousSearchValue == null, now');
      previousPolicySearchValue = null;
    }
  });
}

function setPolicySearchElements() {
  $policySearchResults = $('#policy-search-results');
  $policySearchWrapper = $('#policy-search-wrapper');
  $policySearchGroup   = $('#search-policy');
  $policySearchSpinner = $('#policy-search-spinner');
}

function showPolicySearchResultsAsTypeaheadSuggestions() {
  var searchValue = $policySearchGroup.find('input').val();

  if (searchValue === '') {
    abortPolicyPendingAjaxCall();
    $policySearchWrapper.fadeOut();
    $policySearchResults.addClass('hidden');
  } else {
    if (searchValue.length < minCharsBeforeSearch) {
      $policySearchWrapper.fadeOut();
      $policySearchResults.addClass('hidden');
    }

    if (searchValue !== previousPolicySearchValue && searchValue.length >= minCharsBeforeSearch) {
      $policySearchResults.html('');

      policySuggestionResults = searchMatchingPolicies(searchValue);
      $policySearchResults.removeClass('hidden');
    }
  }
}

function searchMatchingPolicies(searchValue) {
  previousPolicySearchValue = searchValue;

  return loadMatchingPoliciesAsSuggestedResults(searchValue)
}

function loadMatchingPoliciesAsSuggestedResults(searchValue) {
  preparePolicyForSearch();

  policySearchRequest = $.get('/policy_calculations/search', { search_value: searchValue }, function (response) {
                           loadPolicySuggestedResults(response.matchingPoliciesList);
                         })
                         .done(function () { policySearchRequest = null })
                         .fail(function (response) {
                           if (response.statusText !== "abort") {
                             console.log(response);
                             $policySearchWrapper.fadeOut();
                           }
                         });
}

function preparePolicyForSearch() {
  $policySearchSpinner.fadeIn();
  $policySearchWrapper.fadeIn();
  abortPolicyPendingAjaxCall();
}

function loadPolicySuggestedResults(suggestedResults) {
  $policySearchSpinner.fadeOut();
  $policySearchResults.html(suggestedResults);
}

function abortPolicyPendingAjaxCall() {
  if (policySearchRequest != null) {
    // console.log('aborted previous AJAX request');
    policySearchRequest.abort();
  }
}