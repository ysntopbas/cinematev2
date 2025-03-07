import 'package:flutter/material.dart';

class GridViewWidget extends StatelessWidget {
  const GridViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      // reverse: en son elemanı en başa yazmayı sağlar
      // scroll yönünü ayarlar
      scrollDirection: Axis.vertical,
      // crossAxisCount: soldan sağa kaç tane eleman konulacağını belirtiyoruz.
      crossAxisCount: 2,
      // crossAxisSpacing: soldan sağa doğru sütunların arasındaki boşluk miktarı
      crossAxisSpacing: 5,
      // mainAxisSpacing: yukarıdan aşağı sütunlar arasındaki boşluk miktarı
      mainAxisSpacing: 5,
      // her bir elemanın çevresine verilen boşluk miktarı
      // padding: const EdgeInsets.all(0),

      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie,
                  size: 120, color: Theme.of(context).primaryColor),
              Spacer(),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'Film Adı',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie,
                  size: 120, color: Theme.of(context).primaryColor),
              Spacer(),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'Film Adı',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie,
                  size: 120, color: Theme.of(context).primaryColor),
              Spacer(),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'Film Adı',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie,
                  size: 120, color: Theme.of(context).primaryColor),
              Spacer(),
              Divider(
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'Film Adı',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
