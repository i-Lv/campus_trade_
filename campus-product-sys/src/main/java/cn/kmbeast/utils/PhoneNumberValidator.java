package cn.kmbeast.utils;

import java.util.regex.Pattern;

/**
 * 手机号校验工具类
 */
public class PhoneNumberValidator {

    // 中国大陆手机号正则表达式
    private static final String CHINA_MOBILE_PATTERN = "^1[3-9]\\d{9}$";

    // 编译正则表达式模式
    private static final Pattern PHONE_PATTERN = Pattern.compile(CHINA_MOBILE_PATTERN);

    /**
     * 校验是否为有效的中国大陆手机号
     *
     * @param phoneNumber 手机号字符串
     * @return true-有效，false-无效
     */
    public static boolean isValidChinesePhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return false;
        }
        return PHONE_PATTERN.matcher(phoneNumber.trim()).matches();
    }

    /**
     * 校验手机号并抛出异常
     *
     * @param phoneNumber 手机号
     * @throws IllegalArgumentException 如果手机号无效
     */
    public static void validatePhoneNumber(String phoneNumber) {
        if (!isValidChinesePhoneNumber(phoneNumber)) {
            throw new IllegalArgumentException("无效的手机号码: " + phoneNumber);
        }
    }

    /**
     * 校验手机号并返回默认值
     *
     * @param phoneNumber  手机号
     * @param defaultValue 默认值
     * @return 有效手机号返回原值，无效返回默认值
     */
    public static String validateWithDefault(String phoneNumber, String defaultValue) {
        return isValidChinesePhoneNumber(phoneNumber) ? phoneNumber : defaultValue;
    }
}