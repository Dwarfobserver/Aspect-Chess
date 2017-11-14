package aspects;

public class Point {
    int x, y;
    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }
    boolean isOnBoard() {
        return (x >= 0 && x < 8 && y >= 0 && y < 8);
    }
    @Override
    public String toString() {
        return "(" + x + ", " + y + ")";
    }
}
