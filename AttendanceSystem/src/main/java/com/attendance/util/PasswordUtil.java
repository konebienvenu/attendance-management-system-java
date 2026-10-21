package com.attendance.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utilitaire pour le hachage sécurisé des mots de passe avec l'algorithme SHA-256.
 */
public class PasswordUtil {

    /**
     * Hache un mot de passe en clair avec SHA-256 et retourne une chaîne hexadécimale.
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
            throw new RuntimeException("Erreur de hachage SHA-256", e);
        }
    }

    /**
     * Vérifie la concordance entre un mot de passe en clair et un mot de passe haché.
     * Prend aussi en charge le mot de passe en clair pour faciliter les tests initiaux.
     */
    public static boolean verifyPassword(String plainPassword, String storedPassword) {
        if (plainPassword == null || storedPassword == null) {
            return false;
        }
        // Comparaison avec hash SHA-256
        String hashedInput = hashPassword(plainPassword);
        if (hashedInput.equalsIgnoreCase(storedPassword)) {
            return true;
        }
        // Repli : comparaison en clair si la base contient un mot de passe non haché
        return plainPassword.equals(storedPassword);
    }
}
