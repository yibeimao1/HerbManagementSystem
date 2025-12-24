package com.herb.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.io.IOException;

public class JSONUtil {
    private static final ObjectMapper MAPPER = new ObjectMapper();

    static {
        // 配置 ObjectMapper
        MAPPER.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false);
        MAPPER.findAndRegisterModules();
    }

    /**
     * 将对象序列化为 JSON 字符串
     */
    public static String serialize(Object obj) {
        try {
            return MAPPER.writeValueAsString(obj);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("JSON 序列化失败", e);
        }
    }

    /**
     * 将 JSON 字符串反序列化为对象
     */
    public static <T> T deserialize(String json, Class<T> clazz) {
        try {
            return MAPPER.readValue(json, clazz);
        } catch (IOException e) {
            throw new RuntimeException("JSON 反序列化失败", e);
        }
    }
}