struct Stats {
    int n;
    double sum;

    Stats() : n {0}, sum {0.0} {};
    void add(double value) { sum += value; n++; };
    double avg() { return sum/n; };
};
