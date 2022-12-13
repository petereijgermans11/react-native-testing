import React, { useState } from 'react';
import RNPickerSelect from "react-native-picker-select";
import { testProps } from './TestProps';

import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  View,
  Pressable,
  Switch,
} from 'react-native';


export const FormScreen = ({ navigation, route }) => {
  const [isSwitchActive, setSwitchActive] = React.useState(false);
  const toggleSwitch = () => setSwitchActive(previousState => !previousState);
  const [language, setLanguage] = useState("");

  return (

    <SafeAreaView
      style={styles.backgroundStyle}
      testID="app-root"
      accessibilityLabel="app-root">
      <StatusBar barStyle="dark-content" />


      <View style={styles.switchContainer}>
        <Switch
          value={isSwitchActive}
          onValueChange={toggleSwitch}
          style={styles.switch}
          tintColor={'#FF5C06'}
          onTintColor={'#FF5C06'}
          thumbTintColor={'#e3e3e3'}
          {...testProps('switch')}
        />
        <Text style={styles.textStyle} {...testProps('switch-text')}>
          {`Click to turn the switch ${isSwitchActive ? 'OFF' : 'ON'
            }`}
        </Text>
      </View>

      <View style={styles.pickerSelectContainer}>
        <Text>
          {language ?
            `My favourite language is ${language}` :
            "Please select a language"
          }
        </Text>
        <RNPickerSelect
          onValueChange={(language) => setLanguage(language)}
          items={[
            { label: "JavaScript", value: "JavaScript" },
            { label: "TypeScript", value: "TypeScript" },
            { label: "Python", value: "Python" },
            { label: "Java", value: "Java" },
            { label: "C++", value: "C++" },
            { label: "C", value: "C" },
          ]}
          style={pickerSelectStyles}
          {...testProps('picker-select')}
        />
      </View>

      <Pressable
        style={styles.buttonContainer}
        {...testProps('general-info-button')}
        onPress={() => {
          navigation.navigate('Profile')
        }}>

        <Text style={styles.textStyle}>General info</Text>
      </Pressable>

    </SafeAreaView>
  );
};



const pickerSelectStyles = StyleSheet.create({
  inputIOS: {
    fontSize: 16,
    paddingVertical: 12,
    paddingHorizontal: 10,
    borderWidth: 1,
    borderColor: 'gray',
    borderRadius: 4,
    color: 'black',
    paddingRight: 30 // to ensure the text is never behind the icon
  },
  inputAndroid: {
    fontSize: 16,
    paddingHorizontal: 10,
    paddingVertical: 8,
    borderWidth: 0.5,
    borderColor: 'purple',
    borderRadius: 8,
    color: 'black',
    paddingRight: 30 // to ensure the text is never behind the icon
  }
});

const styles = StyleSheet.create({
  pickerSelectContainer: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
    alignItems: "center",
  },
  switchContainer: {
    flex: 1,
    paddingLeft: 10,
    borderBottomColor: '#ea5906',
    borderBottomWidth: 1,
    marginLeft: 10,
    marginRight: 10,
    paddingBottom: 10,
    alignItems: 'flex-start',
  },
  switch: {
    marginTop: 10,
    marginBottom: 10,
  },
  backgroundStyle: {
    flex: 1,
    backgroundColor: '#003f5c',
    justifyContent: 'center',
    alignItems: 'center',
  },
  textStyle: {
    fontSize: 20,
    color: 'white',
  },
  buttonContainer: {
    width: '80%',
    backgroundColor: '#3CB371',
    borderRadius: 25,
    height: 50,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 20,
    marginBottom: 10,
  },
});


