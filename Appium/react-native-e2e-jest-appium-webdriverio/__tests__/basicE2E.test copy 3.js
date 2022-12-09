const wdio = require('webdriverio');
import platformConfig from '../e2e-config';

describe('Appium with Jest automation testing', () => {
  let client;

  beforeAll(async function () {
    const config = {
      path: '/wd/hub',
      port: 4723,
      capabilities: {
        ...platformConfig,
      },
    };

    client = await wdio.remote(config);


  });

  afterAll(async function () {
    await client.pause(1500);
    console.info('[afterAll] Done with testing!');

    await client.deleteSession();
  });

  test('login test', async function () {
    // const loginStatusText = await client.$('~login-status');
    // let loginStatusTextValue = await loginStatusText.getText();
    // expect(loginStatusTextValue).toBe('fail');

    const UsernameTextInput = await client.$('~username-textinput');
    await UsernameTextInput.setValue('Morgan Freeman');
    const UsernameTextInputValue = await UsernameTextInput.getText();
    expect(UsernameTextInputValue).toBe('Morgan Freeman');

    const PasswordTextInput = await client.$('~password-textinput');
    await PasswordTextInput.setValue('god');
    const PasswordTextInputValue = await PasswordTextInput.getText();
    expect(PasswordTextInputValue).toBe('•••');

    const loginButton = await client.$('~login-button');
    await loginButton.click();



    // test switch
    const switchText = await client.$('~switch-text');
    let switchTextValue = await switchText.getText();
    expect(switchTextValue).toBe('Click to turn the switch ON');

    const switchButton = await client.$('~switch');
    await switchButton.click();

    switchTextValue = await switchText.getText();
    expect(switchTextValue).toBe('Click to turn the switch OFF');


    // navigate to general info
    const generalInfoButton = await client.$('~general-info-button');
    await generalInfoButton.click();

    expect(switchTextValue).toBe('Click to turn the switch OFF');


    // test swiping left and right on iOS 
    const slide = await client.$('~slides');
    await slide.touchPerform([
      { action: 'press', options: { x: 360, y: 411 } },
      { action: 'wait', options: { ms: 1000 } },
      { action: 'moveTo', options: { x: 30, y: 411 } },
      { action: 'release' },
    ]);

    await slide.touchPerform([
      { action: 'press', options: { x: 30, y: 411 } },
      { action: 'wait', options: { ms: 1000 } },
      { action: 'moveTo', options: { x: 360, y: 411 } },
      { action: 'release' },
    ]);

    // following line works only on iOS.
    // slide.execute('mobile: swipe', { direction: 'left' });
    // slide.execute('mobile: swipe', { direction: 'right' });
    
    

    ///// E2E testing swiping on Android is not possible !!!


    // following line works only on iOS.
    // test scrolling down screen on iOS
    const scrollview = await client.$('~scrollarea');
    await scrollview.execute('mobile: scroll', { direction: 'down' });


    // test scrolling down screen on Android
    await scrollview.touchPerform([
      { action: 'press', options: { x: 459, y: 1296 } },
      { action: 'wait', options: { ms: 1000 } },
      { action: 'moveTo', options: { x: 459, y: -200 } },
      { action: 'release' }
    ]);

    const endScreen = await client.$('~endscreen');
    let endScreenTextValue = await endScreen.getText();
    expect(endScreenTextValue).toBe('End of screen')




  });

});


