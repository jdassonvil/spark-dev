package myproject.app;

import java.time.LocalDateTime;

public class Rating {

    public int rating;
    public long movie;
    public long user;
    public LocalDateTime timestamp;

    public Rating(int rating, long movie, long user, LocalDateTime timestamp) {
        super();
        this.rating = rating;
        this.movie = movie;
        this.user = user;
        this.timestamp = timestamp;
    }

}
