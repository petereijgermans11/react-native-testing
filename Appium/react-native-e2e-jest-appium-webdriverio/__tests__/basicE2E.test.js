const wdio = require('webdriverio');
import platformConfig from '../e2e-config';

describe('Appium with Jest automation testing', () => {
  let client;

  beforeAll(async () => {
    try { // before running our test
      await client.sleep(4000) // yes, we need to wait for launch screen finish his work before running test, hint of flaky stuff!
    } catch(err) {
      console.log(err) // just in case something goes wrong
    }
  })

  beforeEach(async function () {
    const config = {
      path: '/wd/hub',
      port: 4723,
      capabilities: {
        ...platformConfig,
      },
    };
    client = await wdio.remote(config);

    // login screen test

    const UsernameTextInput = await client.$('~username-textinput');
    await UsernameTextInput.waitForExist({ timeout: 1000 });
    await UsernameTextInput.setValue('Morgan Freeman');
    const UsernameTextInputValue = await UsernameTextInput.getText();
    expect(UsernameTextInputValue).toBe('Morgan Freeman');

    const PasswordTextInput = await client.$('~password-textinput');
    await PasswordTextInput.waitForExist({ timeout: 1000 });
    await PasswordTextInput.setValue('god');
    const PasswordTextInputValue = await PasswordTextInput.getText();
    expect(PasswordTextInputValue).toBe('•••');

    const loginButton = await client.$('~login-button');
    await loginButton.waitForExist({ timeout: 1000 });
    await loginButton.click();

  });

  afterEach(async function () {
    await client.pause(1500);
    console.info('[afterAll] Done with testing!');

    await client.deleteSession();
  });


  // it('login screen test', async function () {
  //   // const loginStatusText = await client.$('~login-status');
  //   // let loginStatusTextValue = await loginStatusText.getText();
  //   // expect(loginStatusTextValue).toBe('fail');
  // });


  test('form screen test', async function () {

    // test switch
    const switchText = await client.$('~switch-text');
    await switchText.waitForExist({ timeout: 1000 });
    let switchTextValue = await switchText.getText();
    expect(switchTextValue).toBe('Click to turn the switch ON');

    const switchButton = await client.$('~switch');
    await switchButton.waitForExist({ timeout: 1000 });
    await switchButton.click();

    switchTextValue = await switchText.getText();
    expect(switchTextValue).toBe('Click to turn the switch OFF');

  });

  test('navigate to general info ', async function () {
    const generalInfoButton = await client.$('~general-info-button');
    await generalInfoButton.waitForExist({ timeout: 1000 });
    await generalInfoButton.click();

    //only for Android. Press back two times because first keyboard gets closed.
    
    // await client.pressKeyCode(4);
    // await client.pressKeyCode(4);
    

    //only for iOS. Press back
    await client.touchPerform([
      { action: 'press', options: { x: 21, y: 72 } },
      { action: 'wait', options: { ms: 1000 } },
      { action: 'release' },
    ]);
  });

  test('general screen test', async function () {
    const generalInfoButton = await client.$('~general-info-button');
    await generalInfoButton.waitForExist({ timeout: 5000 });
    await generalInfoButton.click();

    // test swiping left and right on iOS 
    const slide = await client.$('~slides');
    await slide.waitForExist({ timeout: 1000 });
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


    // following line works only on iOS.
    // test scrolling down screen on iOS
    const scrollarea = await client.$('~scrollviewarea');
    await scrollarea.waitForExist({ timeout: 1000 });
    await scrollarea.execute('mobile: scroll', { direction: 'down' });

    // test scrolling down screen on Android
    await scrollarea.touchPerform([
      { action: 'longPress', options: { x: 459, y: 1296 } },
      { action: 'wait', options: { ms: 1000 } },
      { action: 'moveTo', options: { x: 459, y: -200 } },
      { action: 'release' }
    ]);

    const endScreen = await client.$('~endscreen');
    await endScreen.waitForExist({ timeout: 1000 });
    let endScreenTextValue = await endScreen.getText();
    expect(endScreenTextValue).toBe('End of screen')

  });

});
