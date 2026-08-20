import java.util.Objects;

public class DataCarrier {

    private final String name;
    private final int age;

    public DataCarrier(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DataCarrier that = (DataCarrier) o;
        return age == that.age && Objects.equals(name, that.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, age);
    }

    @Override
    public String toString() {
        return "DataCarrier{name='" + name + "', age=" + age + "}";
    }

    public static void main(String[] args) {
        DataCarrier person = new DataCarrier("Ada", 42);
        System.out.println(person);
    }
}
