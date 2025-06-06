# ML Countdown Widget: ICLR, ICML, NeurIPS (single deadline)

refreshFrequency: 1000  # refresh every second
command: "./ML_Big3_Countdown/ml_fetch.sh"

style: """
  width: auto;
  height: auto;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  
  .confBlock {
    font-family: 'DK Crayon Crumble', serif;
    text-align: center;
    color: white;
    margin-bottom: 25px;
  }

  .confName {
    font-size: 30px;
    font-weight: bold;
  }

  .countdown {
    font-size: 24px;
    margin-top: 5px;
  }

  .confMeta {
    font-size: 16px;
    margin-top: 2px;
    color: #ccc;
  }
"""

render: (output) -> """
  <div class="confWrapper"></div>
"""

update: (output, domEl) ->
  dom = $(domEl)
  wrapper = dom.find(".confWrapper")
  wrapper.empty()

  try
    data = JSON.parse(output)
    now = new Date()
    pad = (n) -> if n < 10 then "0" + n else n

    for conf in data when conf.name
      # Parse deadline as UTC
      deadlineStr = conf.deadline.replace(" ", "T") + "Z"
      base = new Date(deadlineStr)

      # Apply timezone offset
      offsetMinutes = switch conf.timezone
        when "UTC" then 0
        when "UTC-8" then -8 * 60
        when "UTC+1" then 1 * 60
        when "UTC+2" then 2 * 60
        when "UTC-12", "AoE" then -12 * 60
        else 0

      localDeadline = new Date(base.getTime() - offsetMinutes * 60 * 1000)

      if localDeadline > now
        diff = localDeadline - now
        days = Math.floor(diff / (1000 * 60 * 60 * 24))
        hours = Math.floor(diff / (1000 * 60 * 60)) % 24
        minutes = Math.floor(diff / (1000 * 60)) % 60
        seconds = Math.floor(diff / 1000) % 60
        timeStr = "Deadline: #{days}d #{pad(hours)}h #{pad(minutes)}m #{pad(seconds)}s"
      else
        timeStr = "Deadline passed"

      wrapper.append("""
        <div class="confBlock">
          <div class="confName">#{conf.name}’#{String(conf.year).slice(-2)}</div>
          <div class="countdown">#{timeStr}</div>
          <div class="confMeta">#{conf.place} — #{conf.date}</div>
        </div>
      """)

  catch error
    wrapper.html("<div style='color:red;'>Error loading ML conferences</div>")
