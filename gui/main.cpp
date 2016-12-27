#include "proxyman.h"
#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    ProxyMan w;
    w.show();

    return a.exec();
}
