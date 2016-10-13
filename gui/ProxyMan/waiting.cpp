#include "waiting.h"
#include "ui_waiting.h"

Waiting::Waiting(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::Waiting)
{
    ui->setupUi(this);
    hide();
}

Waiting::~Waiting()
{
    delete ui;
}
