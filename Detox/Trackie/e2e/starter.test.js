describe('Example', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should have welcome screen', async () => {
    await element(by.id('MyUniqueId123')).tap();

    await expect(element(by.text('Hello, which manga suits your current mood?'))).toBeVisible();

    await expect(element(by.text('Top Manga'))).toBeVisible();

    //await expect(element(by.text('Romance'))).toBeVisible();

    //await expect(element(by.text('Comedy'))).toBeVisible();
    
    //await waitFor(element(by.text('Hello, which manga suits your current mood?'))).scrollTo('bottom')

    //await element(by.text('Hello, which manga suits your current mood?')).scrollTo('bottom')

    //await element(by.id('scrollView')).scroll(100, 'up');
    //await expect(element(by.text('Top Manga'))).scroll(100, 'up');
    await element(by.text('Top Manga')).tap();
    //await element(by.text('Top Manga')).scrollTo('bottom');

    //await element(by.id('YourCustomComponent')).tap();
    
  

    


    // it('should tap on a button', async () => {
    //   await element(by.id('ButtonID')).tap();
    // });
  });

  // it('should show hello screen after tap', async () => {
  //   await element(by.id('hello_button')).tap();
  //   await expect(element(by.text('Hello!!!'))).toBeVisible();
  // });

  // it('should show world screen after tap', async () => {
  //   await element(by.id('world_button')).tap();
  //   await expect(element(by.text('World!!!'))).toBeVisible();
  // });
});
