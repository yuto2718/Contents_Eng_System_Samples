public class Coordinate
{
    float x,y;
    Coordinate()
    {

    }
    Coordinate(float x, float y)
    {
        this.x = x;
        this.y = y;
    }

    double getDistance(float x, float y)
    {
        return sqrt(pow(x - this.x, 2) + pow(y - this.y, 2));
    }
}