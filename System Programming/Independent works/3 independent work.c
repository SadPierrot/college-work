// 3 самостоятельная 16 вариант 

int main() {
    int res = 0;
    int _c = 0;
    int cur = 0;
    int max = 0;
    FILE* f = fopen("file", "r");
    if(!f)
    {
        perror("[fopen] cannot open the file");
        res = -1;
    }
    while((_c = fgetc(f)) != '\0' && _c != EOF) {
        if(_c >= 'a' && _c <= 'z')
            cur++;
        if(_c == '\n') {
            if(cur > max)
                max = cur;
            cur = 0;
        }
    }
    res = printf("max: %d", max);
    if(res <= 0) {
        perror("[printf] error while printing");
        res = -2;
    }
    return res;
}
