/* eslint-disable react-native/no-inline-styles */
/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

 import React from 'react';
 import { NavigationContainer } from '@react-navigation/native';
 import { createStackNavigator } from '@react-navigation/stack';
 import 'react-native-gesture-handler';
 import { LoginScreen } from './ts/components/Login';
 import { FormScreen } from './ts/components/Form';
 import { ProfileScreen } from './ts/components/Profile';


 const App = () => {
  
   const Stack = createStackNavigator();
 
   return (
     <NavigationContainer>
      <Stack.Navigator>
         <Stack.Screen
           name="Login"
           component={LoginScreen}
           options={{ title: 'Welcome' }}
         />
         <Stack.Screen name="Form" component={FormScreen} />
         <Stack.Screen name="Profile" component={ProfileScreen} />
       </Stack.Navigator>
 
   
     </NavigationContainer>
   );
 };
 
 export default App;
 