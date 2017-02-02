package myproject.app;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Comparator;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

public final class SparkSample {

    public static void main(String[] args) {

        String sparkMaster = "spark://localhost:7077";
        //String sparkMaster = "local";

        SparkConf conf = new SparkConf().setAppName("Spark Sample").setMaster(sparkMaster)
                .setJars(new String[] { "/vagrant/spark-sample/target/sample-1.0.0.jar" });
        JavaSparkContext sc = new JavaSparkContext(conf);

        // JavaRDD<String> lines =
        // sc.textFile("hdfs://localhost:9000/data/ratings.txt");
        JavaRDD<String> lines = sc.textFile("/vagrant/resources/ratings.txt");

        JavaRDD<Rating> ratings = lines.map(line -> line.split("\\t"))
                .map(row -> new Rating(Integer.parseInt(row[2]), Long.parseLong(row[0]), Long.parseLong(row[1]),
                        LocalDateTime.ofInstant(Instant.ofEpochSecond(Long.parseLong(row[3]) * 1000),
                                ZoneId.systemDefault())));

        JavaRDD<Rating> cachedRatingsForUser = ratings.filter(rating -> rating.user == 200).cache();

        double mean = cachedRatingsForUser.mapToDouble(rating -> rating.rating).mean();

        double max = cachedRatingsForUser.mapToDouble(rating -> rating.rating)
                .max(Comparator.<Double>naturalOrder());

        double min = cachedRatingsForUser.mapToDouble(rating -> rating.rating)
                .min(Comparator.<Double>naturalOrder());

        double count = cachedRatingsForUser.count();

        cachedRatingsForUser.unpersist(false);

        System.out.println("mean: " + mean);
        System.out.println("max: " + max);
        System.out.println("min: " + min);
        System.out.println("count: " + count);

        sc.close();
    }
}
