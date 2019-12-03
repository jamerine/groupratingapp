let previousSearchValue  = null;
let suggestionResults    = null;
let claimSearchRequest   = null;
let minCharsBeforeSearch = 1;

let $claimSearchResults  = null;
let $searchGroup         = null;

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

  $searchGroup.click(function(event) {
    if (event.target.parentNode.id === '') {
      // console.log('previousSearchValue == null, now');
      previousSearchValue = null;
    }
  })
}

function setClaimSearchElements() {
  $claimSearchResults = $('#claim-search-results');
  $searchGroup        = $('#search');
}

function showSearchResultsAsTypeaheadSuggestions() {
  let searchValue = $searchGroup.find('input').val();

  if (searchValue === '') {
    abortPendingAjaxCall();
    $claimSearchResults.addClass('hidden');
  } else {
    if (searchValue !== previousSearchValue && searchValue.length >= minCharsBeforeSearch) {
      suggestionResults = searchMatchingClaims(searchValue);
    }

    $claimSearchResults.removeClass('hidden');
  }
}

function searchMatchingClaims(searchValue) {
  previousSearchValue = searchValue;

  return loadMatchingClaimsAsSuggestedResults(searchValue)
}

function loadMatchingClaimsAsSuggestedResults(searchValue) {
  prepareForSearch();

  claimSearchRequest = $.get('http://localhost:3000/claim_calculations/search', { search_value: searchValue }, function(response) {
    loadSuggestedResults(response.matchingClaimsLis);
  })
  .done(function() { claimSearchRequest = null })
  .fail(function(response) {
    if (response.statusText !== "abort") {
      console.log(response);
    }
  });
}

function prepareForSearch() {
  loadSuggestedResults(searchSpinnerLi());
  abortPendingAjaxCall();
}

function loadSuggestedResults(suggestedResults) {
  $claimSearchResults.html(suggestedResults);
}

function abortPendingAjaxCall() {
  if (claimSearchRequest != null) {
    // console.log('aborted previous AJAX request');
    claimSearchRequest.abort()
  }
}

function searchSpinnerLi() {
  return '<li><div id="search-spinner" class="fa fa-cog fa-spin"></div></li>'
}