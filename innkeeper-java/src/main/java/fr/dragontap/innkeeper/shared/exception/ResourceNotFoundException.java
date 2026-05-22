package fr.dragontap.innkeeper.shared.exception;

public class ResourceNotFoundException extends RuntimeException {

    public ResourceNotFoundException() {
        super("Not found");
    }
}
