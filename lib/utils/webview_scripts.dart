const String declineCookiesMessenger = """
  function declineCookies() {
    var declineButton = document.querySelector('button[data-cookiebanner="accept_only_essential_button"]');
    if (declineButton) {
      declineButton.click();
    }

    var manageDialogAcceptButton = document.querySelector('button[data-testid="cookie-policy-manage-dialog-accept-button"]');
    if (manageDialogAcceptButton) {
      manageDialogAcceptButton.click();
    }
  }
""";

const String applyCustomStylesMessenger = """
  function applyCustomStyles() {
    var emailField = document.querySelector('input[name="email"]');
    if (emailField) {
      emailField.style.height = '70px';
      emailField.style.width = '80%';
      emailField.style.fontSize = '32px';
      emailField.style.padding = '14px';
      emailField.style.border = '2px solid #ccc';
      emailField.style.borderRadius = '8px';
      emailField.style.marginBottom = '20px';
    }
  
    var passField = document.querySelector('input[name="pass"]');
    if (passField) {
      passField.style.height = '70px';
      passField.style.width = '80%';
      passField.style.fontSize = '32px';
      passField.style.padding = '14px';
      passField.style.border = '2px solid #ccc';
      passField.style.borderRadius = '8px';
      passField.style.marginBottom = '20px';
    }
  
    var loginButton = document.querySelector('button[name="login"]');
    if (loginButton) {
      loginButton.style.height = '70px';
      loginButton.style.fontSize = '32px';
      loginButton.style.width = '80%';
      loginButton.style.marginTop = '22px';
      loginButton.style.padding = '14px';
      loginButton.style.border = 'none';
      loginButton.style.borderRadius = '8px';
      loginButton.style.backgroundColor = '#007bff';
      loginButton.style.color = '#fff';
    }
  
    var uiInputLabel = document.querySelector('.uiInputLabel.clearfix');
    if (uiInputLabel) {
      uiInputLabel.style.display = 'none';
    }
  
    var specificDiv = document.querySelector('._210n._7mqw');
    if (specificDiv) {
      specificDiv.style.display = 'none';
    }
  
    var imgElement = document.querySelector('img.img');
    if (imgElement) {
      imgElement.setAttribute('style', 'height: 150px !important; width: 150px !important;');
    }
  }
""";

String getCombinedScriptMessenger() {
  return """
    $declineCookiesMessenger
    $applyCustomStylesMessenger
    declineCookies();
    setTimeout(applyCustomStyles, 50);
  """;
}
