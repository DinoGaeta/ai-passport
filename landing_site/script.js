document.getElementById('waitlist-form').addEventListener('submit', function (e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const btn = this.querySelector('button');
    const successSection = document.getElementById('success-section');

    // Simulate API call
    btn.textContent = 'Joining...';
    btn.disabled = true;

    setTimeout(() => {
        this.style.display = 'none';
        successSection.classList.remove('hidden');

        // Here you would typically send the email to your backend or a service like Mailchimp/Formspree
        console.log(`New waitlist signup: ${email}`);
    }, 1000);
});
