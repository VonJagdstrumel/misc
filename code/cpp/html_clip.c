#include <stdio.h>
#include <windows.h>

#define strpos(buf, search) strstr(buf, search) - buf
#define CF_HTML RegisterClipboardFormat("HTML Format")

void update_prop(char *buf, const char *prop, unsigned int value) {
    char *ptr = strstr(buf, prop);
    size_t size = strlen(prop) + 1;
    sprintf(ptr + size, "%08u", value);
    ptr[size + 8] = '\n';
}

HGLOBAL clip_put(unsigned int type, char *buf) {
    HGLOBAL handle = GlobalAlloc(GMEM_MOVEABLE, strlen(buf) + 1);
    char *ptr = GlobalLock(handle);
    strcpy(ptr, buf);
    GlobalUnlock(handle);
    SetClipboardData(type, handle);
    return handle;
}

void copy_html(char *html, char *text) {
    char *buf = malloc(170 + strlen(html));

    strcpy(buf, "Version:0.9\n"
            "StartHTML:00000000\n"
            "EndHTML:00000000\n"
            "StartFragment:00000000\n"
            "EndFragment:00000000\n"
            "<html><body><!--StartFragment-->");
    strcat(buf, html);
    strcat(buf, "<!--EndFragment--></body></html>");

    update_prop(buf, "StartHTML", strpos(buf, "<html>"));
    update_prop(buf, "EndHTML", strlen(buf));
    update_prop(buf, "StartFragment", strpos(buf, "<!--StartFragment-->"));
    update_prop(buf, "EndFragment", strpos(buf, "<!--EndFragment-->"));

    OpenClipboard(0);
    EmptyClipboard();
    HGLOBAL h1 = clip_put(CF_HTML, buf);
    HGLOBAL h2 = clip_put(CF_TEXT, text);
    CloseClipboard();
    GlobalFree(h1);
    GlobalFree(h2);

    free(buf);
}

int main(int argc, char **argv) {
    if (argc == 3) {
        copy_html(argv[1], argv[2]);
    }
}
