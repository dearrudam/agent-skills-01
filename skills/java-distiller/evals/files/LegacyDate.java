import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class LegacyDate {

    public String formatNextWeek(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_MONTH, 7);
        Date nextWeek = calendar.getTime();
        return sdf.format(nextWeek);
    }

    public static void main(String[] args) {
        LegacyDate legacy = new LegacyDate();
        System.out.println(legacy.formatNextWeek(new Date()));
    }
}
