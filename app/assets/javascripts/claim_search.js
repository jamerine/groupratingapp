var minCharsBeforeSearch = 3,
    previousSearchValue  = null,
    suggestionResults    = null,
    claimSearchRequest   = null,
    $claimSearchResults  = null,
    $searchGroup         = null,
    $searchSpinner       = null,
    $searchWrapper       = null;

function claimSearchListenerAndResults() {
  setClaimSearchElements();

  $searchGroup.keyup(function (e) {
    console.log(e.key);

    if (e.key === 'Enter') e.preventDefault();
    if (e.key === 'Escape') {
      $searchSpinner.fadeOut();
      $searchWrapper.fadeOut();
      $claimSearchResults.html('');
      $claimSearchResults.addClass('hidden');
    }

    showSearchResultsAsTypeaheadSuggestions();
  });

  $searchGroup.click(function (event) {
    if (event.target.parentNode.id === '') {
      // console.log('previousSearchValue == null, now');
      previousSearchValue = null;
    }
  });
}

function setClaimSearchElements() {
  $claimSearchResults = $('#claim-search-results');
  $searchWrapper      = $('#claim-search-wrapper');
  $searchGroup        = $('#search-claim');
  $searchSpinner      = $('#search-spinner');
}

function showSearchResultsAsTypeaheadSuggestions() {
  var searchValue = $searchGroup.find('input').val();

  if (searchValue === '') {
    abortPendingAjaxCall();
    $searchWrapper.fadeOut();
    $claimSearchResults.addClass('hidden');
  } else {
    if (searchValue.length < minCharsBeforeSearch) {
      $searchWrapper.fadeOut();
      $claimSearchResults.addClass('hidden');
    }

    if (searchValue !== previousSearchValue && searchValue.length >= minCharsBeforeSearch) {
      $claimSearchResults.html('');

      suggestionResults = searchMatchingClaims(searchValue);
      $claimSearchResults.removeClass('hidden');
    }
  }
}

function searchMatchingClaims(searchValue) {
  previousSearchValue = searchValue;

  return loadMatchingClaimsAsSuggestedResults(searchValue)
}

function loadMatchingClaimsAsSuggestedResults(searchValue) {
  prepareForSearch();

  claimSearchRequest = $.get('/claim_calculations/search', { search_value: searchValue }, function (response) {
                          loadSuggestedResults(response.matchingClaimsList);
                        })
                        .done(function () { claimSearchRequest = null })
                        .fail(function (response) {
                          if (response.statusText !== "abort") {
                            console.log(response);
                            $searchWrapper.fadeOut();
                          }
                        });
}

function prepareForSearch() {
  $searchSpinner.fadeIn();
  $searchWrapper.fadeIn();
  abortPendingAjaxCall();
}

function loadSuggestedResults(suggestedResults) {
  $searchSpinner.fadeOut();
  $claimSearchResults.html(suggestedResults);
}

function abortPendingAjaxCall() {
  if (claimSearchRequest != null) {
    // console.log('aborted previous AJAX request');
    claimSearchRequest.abort();
  }
}