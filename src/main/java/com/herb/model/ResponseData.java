package com.herb.model;

public class ResponseData<T> {
    private int code;        // 状态码: 200成功, 400失败
    private String message;  // 提示信息
    private T data;          // 响应数据

    public ResponseData() {
    }

    public ResponseData(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    // 成功响应
    public static <T> ResponseData<T> success(T data) {
        return new ResponseData<>(200, "操作成功", data);
    }

    public static <T> ResponseData<T> success(String message, T data) {
        return new ResponseData<>(200, message, data);
    }

    // 失败响应
    public static <T> ResponseData<T> error(String message) {
        return new ResponseData<>(400, message, null);
    }

    // Getters and Setters
    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}