let minCharsBeforeSearch = 3,
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
    if (e.key === 'Enter') {
      // TODO: build logic for this state that matches pressing the search button
      console.log('submit search due to manual search, only exact match returns result to navigate to claim')
    } else {
      showSearchResultsAsTypeaheadSuggestions();
    }
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
  let searchValue = $searchGroup.find('input').val();

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