controladdin HTML
{
    RequestedHeight = 300;
    MinimumHeight = 300;
    MaximumHeight = 300;
    RequestedWidth = 700;
    MinimumWidth = 700;
    MaximumWidth = 700;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    Scripts = './Objects/Generic/HTML Addin/script.js';
    // StyleSheets =
    // 'style.css';
    StartupScript = './Objects/Generic/HTML Addin/startup.js';
    // RecreateScript = 'recreateScript.js';
    // RefreshScript = 'refreshScript.js';
    // Images = 
    //     'image1.png',
    //     'image2.png';

    event ControlReady();

    procedure Render(html: Text);
}