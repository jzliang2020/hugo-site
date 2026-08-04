document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.article-content pre.wp-block-code').forEach(function (pre) {
        if (pre.querySelector('.wp-code-copy')) return;

        var button = document.createElement('button');
        button.type = 'button';
        button.className = 'wp-code-copy';
        button.textContent = 'Copy';

        button.addEventListener('click', function () {
            var code = pre.querySelector('code');
            var text = code ? code.textContent : pre.textContent;

            navigator.clipboard.writeText(text).then(function () {
                button.textContent = 'Copied';
                setTimeout(function () {
                    button.textContent = 'Copy';
                }, 1200);
            });
        });

        pre.appendChild(button);
    });
});
