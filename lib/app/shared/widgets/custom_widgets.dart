import 'package:flutter/material.dart';

import '../../modules/webview/webview_page.dart';

Widget buildLinkInfo(
    BuildContext context, String label, String value, String url) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(
            url: url.startsWith('http') ? url : 'https://$url',
            title: label,
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
              label == "email"
                  ? Icons.mail_outline
                  : label == "site"
                      ? Icons.link
                      : Icons.alternate_email_outlined,
              color: const Color.fromARGB(255, 87, 82, 82)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                  color: Color.fromARGB(255, 87, 82, 82),
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildInfoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color.fromARGB(255, 87, 82, 82)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 87, 82, 82)),
          ),
        ),
      ],
    ),
  );
}
