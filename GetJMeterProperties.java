import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Properties;
import java.util.stream.Stream;

public class GetJMeterProperties {
  public static void main(String[] args) {

    Path workspacePath = Paths.get("/opt/workspace");
    Stream<Path> paths;
    try {
      paths = Files.list(workspacePath);
    } catch (IOException e) {
      return;
    }

    paths.forEach(path -> {
      if (!path.toString().endsWith(".properties")) {
        return;
      }
      Properties properties = new Properties();
      try {
        properties.load(Files.newInputStream(path));
      } catch (IOException e) {
        return;
      }

      properties.forEach((key, value) -> {
        System.out.println(String.format("-J%s=%s", String.valueOf(key), String.valueOf(value)));
      });
    });

    paths.close();

  }
}
