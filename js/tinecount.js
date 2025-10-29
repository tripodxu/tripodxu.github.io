
//版权图标动态显示
document.addEventListener('DOMContentLoaded', function() {
    const currentYear = new Date().getFullYear();
    const copyrightElement = document.querySelector('.copyright');
    if (copyrightElement) {
        copyrightElement.innerHTML = `©网站起始时间 - ${currentYear} <i class="fa-fw fas fa-star fa-beat" style="color: #ffff00;"></i> By 博主名`;
    }
});

// 运行时间动态显示
function showDateTime() {
    const timeDisplay = document.getElementById('span_dt_dt');
    if (!timeDisplay) return;

    const startTime = new Date("2024-09-05T15:41:23");
    const now = new Date();
    const elapsedMilliseconds = now - startTime;
    const seconds = Math.floor(elapsedMilliseconds / 1000);

    const oneYearInSeconds = 365 * 24 * 60 * 60;
    if (seconds < oneYearInSeconds) {
        const days = Math.floor(seconds / (24 * 60 * 60));
        const remainingSecondsAfterDays = seconds % (24 * 60 * 60);
        const hours = Math.floor(remainingSecondsAfterDays / (60 * 60));
        const remainingSecondsAfterHours = remainingSecondsAfterDays % (60 * 60);
        const minutes = Math.floor(remainingSecondsAfterHours / 60);
        const sec = remainingSecondsAfterHours % 60;

        timeDisplay.innerHTML = `
            <span style="color:#ffff00">${days}</span> 天 
            <span style="color:#ffff00">${hours}</span> 时 
            <span style="color:#ffff00">${minutes}</span> 分 
            <span style="color:#ffff00">${sec}</span> 秒
        `;
    } else {
        const years = Math.floor(seconds / oneYearInSeconds);
        const remainingSecondsAfterYears = seconds % oneYearInSeconds;
        const days = Math.floor(remainingSecondsAfterYears / (24 * 60 * 60));
        const remainingSecondsAfterDays = remainingSecondsAfterYears % (24 * 60 * 60);
        const hours = Math.floor(remainingSecondsAfterDays / (60 * 60));
        const remainingSecondsAfterHours = remainingSecondsAfterDays % (60 * 60);
        const minutes = Math.floor(remainingSecondsAfterHours / 60);
        const sec = remainingSecondsAfterHours % 60;

        timeDisplay.innerHTML = `
            <span style="color:#ffff00">${years}</span> 年 
            <span style="color:#ffff00">${days}</span> 天 
            <span style="color:#ffff00">${hours}</span> 时 
            <span style="color:#ffff00">${minutes}</span> 分 
            <span style="color:#ffff00">${sec}</span> 秒
        `;
    }

    setTimeout(showDateTime, 1000);
}

document.addEventListener('DOMContentLoaded', () => {
    const frameworkInfo = document.querySelector('.framework-info');
    if (frameworkInfo) {
        frameworkInfo.innerHTML = '本站已运行<span id="span_dt_dt"></span>';
    }
    showDateTime();
});   
  
