package fr.dragontap.innkeeper.shared.exception;

import lombok.Getter;

import java.util.List;

@Getter
public class ValidationException extends RuntimeException {

    private final List<FieldError> details;

    public ValidationException(String field, String message) {
        this(List.of(new FieldError(field, message)));
    }

    public ValidationException(List<FieldError> details) {
        super("Validation failed");
        this.details = details;
    }

    public record FieldError(String field, String message) {}
}
