// チャットメッセージ画面を一番下までスクロール
window.onload = function() {
    function scrollToEnd() {
        const message = document.getElementById('message');
        message.scrollTop = message.scrollHeight;
    }
    scrollToEnd()
};