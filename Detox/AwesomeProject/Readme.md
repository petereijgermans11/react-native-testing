

## Getting startted with Detox testing

### step 1 environment-setup react-native
https://reactnative.dev/docs/next/environment-setup

do not forget to run: `pod install` in the `/ios` directory

### step 2 getting startted with Detox testing
https://wix.github.io/Detox/docs/introduction/getting-started/

### step 3 tutorial swiping
Folllow tutorial for swiping: https://blog.logrocket.com/react-native-end-to-end-testing-detox/

### step 4 final test example
see for final test: https://github.com/petereijgermans11

### Quick steps to startup testing with Detox for ios:
1. After every change run a Detox build:   `detox build --configuration ios.sim.debug`
2. run `Metro` with:    `yarn start`
3. run tests with:    `detox test --configuration ios.sim.debug`

### Quick steps to startup testing with Detox for Android:
1. After every change run a Detox build:   `detox build --configuration android.emu.debug`
2. run `Metro` with:    `yarn start`
3. run tests with:    `detox test --configuration android.emu.debug`
