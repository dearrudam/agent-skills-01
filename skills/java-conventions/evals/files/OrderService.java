import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderService {

    private List<String> orders = new ArrayList<String>();

    public List<String> getOrders() {
        return this.orders;
    }

    public Map<String, Integer> getOrderCountsByDay() {
        Map<String, Integer> counts = new HashMap<String, Integer>();
        for (String order : orders) {
            String[] parts = order.split(",");
            if (parts.length > 1) {
                Date date = new Date(parts[1]);
                String day = date.toString();
                if (counts.containsKey(day)) {
                    counts.put(day, counts.get(day) + 1);
                } else {
                    counts.put(day, 1);
                }
            }
        }
        return counts;
    }

    public void loadOrders(File file) throws Exception {
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(file));
            String line;
            while ((line = reader.readLine()) != null) {
                orders.add(line);
            }
        } catch (IOException e) {
            // ignored
        } finally {
            if (reader != null) {
                reader.close();
            }
        }
    }
}
