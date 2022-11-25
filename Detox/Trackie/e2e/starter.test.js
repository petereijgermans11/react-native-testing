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

 
    await element(by.text('Top Manga')).tap();
    //await element(by.text('Top Manga')).scrollTo('bottom');

    // it('should tap on a button', async () => {
    //   await element(by.id('ButtonID')).tap();
    // });
  });

 
});
