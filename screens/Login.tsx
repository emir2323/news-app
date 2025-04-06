import React, { useState, useEffect } from 'react';
import { View, TextInput, TouchableOpacity, StyleSheet, Image, KeyboardAvoidingView, Platform, Alert, ActivityIndicator, Text } from 'react-native';
import { ThemedText } from '../components/ThemedText';
import { ThemedView } from '../components/ThemedView';
import { LinearGradient } from 'expo-linear-gradient';
import { auth } from '../config/firebase';
import { signInWithEmailAndPassword, sendPasswordResetEmail, createUserWithEmailAndPassword } from 'firebase/auth';
import { router } from 'expo-router';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [isRegistering, setIsRegistering] = useState(false);
  const [emailError, setEmailError] = useState('');
  const [passwordError, setPasswordError] = useState('');

  // Form doğrulama
  const validateForm = () => {
    let isValid = true;
    
    // Email doğrulama
    if (!email || !/\S+@\S+\.\S+/.test(email)) {
      setEmailError('Geçerli bir e-posta adresi giriniz');
      isValid = false;
    } else {
      setEmailError('');
    }
    
    // Şifre doğrulama
    if (!password || password.length < 6) {
      setPasswordError('Şifre en az 6 karakter olmalıdır');
      isValid = false;
    } else {
      setPasswordError('');
    }
    
    // Kayıt olurken şifre onayı
    if (isRegistering && password !== confirmPassword) {
      setPasswordError('Şifreler eşleşmiyor');
      isValid = false;
    }
    
    return isValid;
  };

  const handleLogin = async () => {
    if (!validateForm()) return;
    
    setIsLoading(true);
    try {
      await signInWithEmailAndPassword(auth, email, password);
      console.log('Giriş başarılı!');
      // Başarılı giriş sonrası ana sayfaya yönlendirme
      router.replace('/(tabs)');
    } catch (error) {
      console.error('Giriş hatası:', (error as Error).message);
      Alert.alert('Giriş Hatası', 'E-posta veya şifre hatalı. Lütfen tekrar deneyin.');
    } finally {
      setIsLoading(false);
    }
  };
  
  const handleRegister = async () => {
    if (!validateForm()) return;
    
    setIsLoading(true);
    try {
      await createUserWithEmailAndPassword(auth, email, password);
      Alert.alert('Başarılı', 'Hesabınız oluşturuldu! Şimdi giriş yapabilirsiniz.');
      setIsRegistering(false);
    } catch (error) {
      console.error('Kayıt hatası:', (error as Error).message);
      Alert.alert('Kayıt Hatası', 'Kayıt işlemi sırasında bir hata oluştu. Lütfen tekrar deneyin.');
    } finally {
      setIsLoading(false);
    }
  };
  
  const handleForgotPassword = async () => {
    if (!email || !/\S+@\S+\.\S+/.test(email)) {
      Alert.alert('Hata', 'Lütfen geçerli bir e-posta adresi giriniz.');
      return;
    }
    
    setIsLoading(true);
    try {
      await sendPasswordResetEmail(auth, email);
      Alert.alert('Başarılı', 'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.');
    } catch (error) {
      console.error('Şifre sıfırlama hatası:',(error as Error).message);
      Alert.alert('Hata', 'Şifre sıfırlama işlemi sırasında bir hata oluştu. Lütfen tekrar deneyin.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={styles.container}
    >
      <LinearGradient
        colors={['#4c669f', '#3b5998', '#192f6a']}
        style={styles.gradientBackground}
      >
        <Image
          source={require('../assets/images/react-logo.png')}
          style={styles.logo}
        />
        <View style={styles.inputContainer}>
          <Text style={styles.headerText}>{isRegistering ? 'Yeni Hesap Oluştur' : 'Hoş Geldiniz'}</Text>
          
          <TextInput
            style={[styles.input, emailError ? styles.inputError : null]}
            placeholder="E-posta"
            placeholderTextColor="#AAA"
            value={email}
            onChangeText={(text) => {
              setEmail(text);
              setEmailError('');
            }}
            autoCapitalize="none"
            keyboardType="email-address"
          />
          {emailError ? <Text style={styles.errorText}>{emailError}</Text> : null}
          
          <TextInput
            style={[styles.input, passwordError ? styles.inputError : null]}
            placeholder="Şifre"
            placeholderTextColor="#AAA"
            value={password}
            onChangeText={(text) => {
              setPassword(text);
              setPasswordError('');
            }}
            secureTextEntry
          />
          {passwordError ? <Text style={styles.errorText}>{passwordError}</Text> : null}
          
          {isRegistering && (
            <TextInput
              style={[styles.input, passwordError && confirmPassword !== password ? styles.inputError : null]}
              placeholder="Şifreyi Tekrar Girin"
              placeholderTextColor="#AAA"
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              secureTextEntry
            />
          )}
          
          {isLoading ? (
            <ActivityIndicator size="large" color="#FFFFFF" style={{ marginVertical: 10 }} />
          ) : (
            <TouchableOpacity 
              style={styles.loginButton} 
              onPress={isRegistering ? handleRegister : handleLogin}
            >
              <ThemedText style={{ color: '#FFFFFF', fontSize: 16, fontWeight: 'bold' }}>
                {isRegistering ? 'Kayıt Ol' : 'Giriş Yap'}
              </ThemedText>
            </TouchableOpacity>
          )}
          
          <View style={{ flexDirection: 'row', justifyContent: 'space-between', marginTop: 15 }}>
            {!isRegistering && (
              <TouchableOpacity onPress={handleForgotPassword}>
                <ThemedText style={{ color: '#4361EE', textDecorationLine: 'underline' }}>Şifremi Unuttum</ThemedText>
              </TouchableOpacity>
            )}
            <TouchableOpacity onPress={() => {
              setIsRegistering(!isRegistering);
              setEmailError('');
              setPasswordError('');
              setConfirmPassword('');
            }}>
              <ThemedText style={{ color: '#4361EE', textDecorationLine: 'underline' }}>
                {isRegistering ? 'Giriş Yap' : 'Kayıt Ol'}
              </ThemedText>
            </TouchableOpacity>
          </View>
        </View>
      </LinearGradient>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  gradientBackground: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  logo: {
    width: 150,
    height: 150,
    marginBottom: 30,
    resizeMode: 'contain',
  },
  headerText: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 20,
    textAlign: 'center',
  },
  inputContainer: {
    width: '100%',
    maxWidth: 400,
    backgroundColor: 'rgba(255, 255, 255, 0.15)',
    borderRadius: 15,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation: 5,
  },
  input: {
    backgroundColor: 'rgba(255, 255, 255, 0.9)',
    borderRadius: 10,
    padding: 15,
    marginBottom: 15,
    fontSize: 16,
    color: '#333',
  },
  inputError: {
    borderWidth: 1,
    borderColor: '#FF6B6B',
  },
  errorText: {
    color: '#FF6B6B',
    fontSize: 12,
    marginBottom: 10,
    marginTop: -10,
  },
  loginButton: {
    backgroundColor: '#4361EE',
    borderRadius: 10,
    padding: 15,
    alignItems: 'center',
    marginTop: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
    elevation:0,

  },
});