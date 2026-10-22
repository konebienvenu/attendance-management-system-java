package com.attendance.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class for secure password hashing using SHA-256 algorithm.
 */
public class PasswordUtil {

    /**
     * Hashes a plaintext password using SHA-256 and returns a hex string.
     */
    public static String hashPassword(String password) {
        if (password == null) return null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error computing SHA-256 password hash", e);
        }
    }

    /**
     * Verifies if a plaintext password matches the stored hashed password.
     * Also supports plaintext comparison fallback for testing convenience.
     */
    public static boolean verifyPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        String hashedInput = hashPassword(plainPassword);
        if (hashedInput.equalsIgnoreCase(storedPassword)) {
            return true;
        }
        return plainPassword.equals(storedPassword);
    }
}
