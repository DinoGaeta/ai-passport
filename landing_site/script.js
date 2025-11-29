document.getElementById('waitlist-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const btn = this.querySelector('button');
    const successMsg = document.getElementById('success-message');

    // Simulate API call
    btn.textContent = 'Joining...';
    btn.disabled = true;

    setTimeout(() => {
        this.style.display = 'none';
        successMsg.classList.remove('hidden');

        // Here you would typically send the email to your backend or a service like Mailchimp/Formspree
        console.log(`New waitlist signup: ${email}`);
    }, 1000);
});
