package com.uniplan.planner.global.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(TimetableNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleTimetableNotFoundException(TimetableNotFoundException e) {
        ErrorResponse error = new ErrorResponse(HttpStatus.NOT_FOUND.value(), e.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(DuplicateCourseException.class)
    public ResponseEntity<ErrorResponse> handleDuplicateCourseException(DuplicateCourseException e) {
        ErrorResponse error = new ErrorResponse(HttpStatus.CONFLICT.value(), e.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
    }

    @ExceptionHandler(ScenarioNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleScenarioNotFoundException(ScenarioNotFoundException e) {
        ErrorResponse error = new ErrorResponse(HttpStatus.NOT_FOUND.value(), e.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(RegistrationNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleRegistrationNotFoundException(RegistrationNotFoundException e) {
        ErrorResponse error = new ErrorResponse(HttpStatus.NOT_FOUND.value(), e.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(WishlistItemNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleWishlistItemNotFoundException(WishlistItemNotFoundException e) {
        ErrorResponse error = new ErrorResponse(HttpStatus.NOT_FOUND.value(), e.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(DuplicateWishlistItemException.class)
    public ResponseEntity<ErrorResponse> handleDuplicateWishlistItemException(DuplicateWishlistItemException e) {
        ErrorResponse error = new ErrorResponse(HttpStatus.CONFLICT.value(), e.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errors);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneralException(Exception e) {
        ErrorResponse error = new ErrorResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(), "서버 오류가 발생했습니다");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }

    public record ErrorResponse(int status, String message) {}
}