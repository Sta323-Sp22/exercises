library(tidyverse)

set.seed(3212016)
d = data.frame(x = 1:120) %>%
  mutate(y = sin(2*pi*x/120) + runif(length(x),-1,1))

l = loess(y ~ x, data=d)
p = predict(l, se=TRUE)
d = d %>% mutate(
  pred_y = p$fit,
  pred_y_se = p$se.fit
)

n_rep = 10000

system.time({ 
  bs = purrr::map_dfr(
    seq_len(n_rep),
    function(i) {
      d %>%
        select(x,y) %>%
        slice_sample(prop=1, replace=TRUE) %>%
        mutate(
          .,
          iter = i,
          pred = loess(y~x, data = .) %>% predict()
        )
    }
  )
})

#  user  system elapsed 
# 7.778   0.025   7.997 

tibble::as_tibble(bs)

bs_res = bs %>%
  group_by(x, y) %>%
  summarize(
    mean = mean(pred),
    bs_low = quantile(pred, probs=0.025),
    bs_upp = quantile(pred, probs=0.975),
    .groups = "drop"
  )
bs_res


ggplot(d, aes(x,y)) +
  geom_point(color="gray50") +
  geom_ribbon(
    aes(ymin = pred_y - 1.96 * pred_y_se, 
        ymax = pred_y + 1.96 * pred_y_se), 
    fill="red", alpha=0.25
  ) +
  geom_line(
    aes(x, mean), data = bs_res, color="blue"
  ) +
  geom_ribbon(
    aes(ymin = bs_low, 
        ymax = bs_upp), 
    data = bs_res,
    fill="green", alpha=0.25
  ) +
  geom_line(aes(y=pred_y)) +
  theme_bw()



future::plan(future::multisession, workers=8)

system.time({ 
  bs = furrr::future_map_dfr(
    seq_len(n_rep),
    function(i) {
      d %>%
        select(x,y) %>%
        slice_sample(prop=1, replace=TRUE) %>%
        mutate(
          .,
          iter = i,
          pred = loess(y~x, data = .) %>% predict()
        )
    }
  )
})

