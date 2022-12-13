import platformConfig from '../e2e-config';

import { Then, Given, Before } from '@cucumber/cucumber';

Given('I should see the {string} element', async (elementId) => {
  await platformConfig.expect(element(by.id(elementId))).toBeVisible();
});

