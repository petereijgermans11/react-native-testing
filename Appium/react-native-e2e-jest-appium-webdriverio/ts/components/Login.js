import React from 'react';
import {
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  View,
  Pressable,
  TextInput,
} from 'react-native';
import { testProps } from './TestProps';

export const LoginScreen = ({ navigation }) => {
  const [username, setUsername] = React.useState('username');
  const [password, setPassword] = React.useState('password');
  const [login, setLogin] = React.useState(false);
  const reset = () => {
    setUsername('');
    setPassword('');
    setLogin(false);
  };

  return (
    <SafeAreaView
      style={styles.backgroundStyle}
      testID="app-root"
      accessibilityLabel="app-root">
      <StatusBar barStyle="dark-content" />

      {/* <Text {...testProps('login-status', true)} style={styles.loginStatus}>
        {route.params.login ? 'success' : route.params.login}
      </Text> */}

      <View style={styles.inputContainer}>
        <TextInput
          name="username"
          {...testProps('username-textinput')}
          placeholder={username}
          placeholderTextColor="#003f5c"
          style={styles.inputText}
          onChangeText={setUsername}
          value={username}
        />
      </View>

      <View style={styles.inputContainer}>
        <TextInput
          name="password"
          {...testProps('password-textinput')}
          secureTextEntry={true}
          placeholder={password}
          placeholderTextColor="#003f5c"
          style={styles.inputText}
          onChangeText={setPassword}
          value={password}
        />
      </View>

      <Pressable
        style={styles.buttonContainer}
        {...testProps('login-button')}
        onPress={() => {
          setLogin(true);
          navigation.navigate('Form', { login })
        }}>

        <Text style={styles.textStyle}>Login</Text>
      </Pressable>

      <Pressable
        style={[styles.buttonContainer, { backgroundColor: 'coral' }]}
        {...testProps('reset-button')}
        onPress={reset}>
        <Text style={styles.textStyle}>Reset</Text>
      </Pressable>

    </SafeAreaView>

  );
};

const styles = StyleSheet.create({
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
  loginStatus: {
    fontSize: 30,
    color: 'white',
  },
  inputContainer: {
    width: '80%',
    backgroundColor: '#465881',
    borderRadius: 25,
    height: 50,
    marginBottom: 20,
    justifyContent: 'center',
    padding: 20,
  },
  inputText: {
    height: 50,
    color: 'black',
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


