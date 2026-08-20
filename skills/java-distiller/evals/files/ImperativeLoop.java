import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ImperativeLoop {

    public List<String> transform(List<String> input) {
        List<String> result = new ArrayList<String>();
        for (int i = 0; i < input.size(); i++) {
            String value = input.get(i);
            if (value.startsWith("a")) {
                result.add(value.toUpperCase());
            }
        }
        return result;
    }

    public static void main(String[] args) {
        ImperativeLoop loop = new ImperativeLoop();
        List<String> input = Arrays.asList("apple", "banana", "avocado");
        System.out.println(loop.transform(input));
    }
}
